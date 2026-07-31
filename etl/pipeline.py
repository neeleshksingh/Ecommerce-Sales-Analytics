from etl.reset_database import main as reset_database
from etl.setup_database import main as setup_database
from etl.load_data import main as load_data
from etl.run_validation import main as run_validation
from etl.run_constraints import main as run_constraints

PIPELINE = [
    ("Reset Database", reset_database),
    ("Setup Database", setup_database),
    ("Load Data", load_data),
    ("Run Validation", run_validation),
    ("Apply Constraints", run_constraints),
]


def main():
    print("=" * 80)
    print("Ecommerce Sales Analytics Pipeline")
    print("=" * 80)

    for step_name, step_function in PIPELINE:

        print(f"\n🚀 {step_name}")

        step_function()

    print("\n🎉 Pipeline completed successfully!")


if __name__ == "__main__":
    main()