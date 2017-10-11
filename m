From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 17/19] ext4: Add support for MAP_SYNC flag
Date: Wed, 11 Oct 2017 15:11:21 -0700
Message-ID: <CAPcyv4gZw0QCG08Qs8dP8TMhgXo0_KcVq-33uhaG8QuwxXT=Wg@mail.gmail.com>
References: <20171011200603.27442-1-jack@suse.cz> <20171011200603.27442-18-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ted Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20171011200603.27442-18-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 11, 2017 at 1:06 PM, Jan Kara <jack@suse.cz> wrote:
> Now when everything is prepared, add support in ext4 to accept MAP_SYNC
> as an mmap(2) flag.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 61a8788168f3..f013cda84b3d 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -364,6 +364,25 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
>         return 0;
>  }
>
> +#define EXT4_SUPPORTED_MAP_FLAGS (LEGACY_MAP_MASK | MAP_SYNC)
> +
> +static int ext4_file_mmap_validate(struct file *file,
> +                                  struct vm_area_struct *vma,
> +                                  unsigned long map_flags)
> +{
> +       if (map_flags & ~EXT4_SUPPORTED_MAP_FLAGS)
> +               return -EOPNOTSUPP;
> +
> +       /*
> +        * We don't support synchronous mappings for non-DAX files. At least
> +        * until someone comes with a sensible use case.
> +        */
> +       if (!IS_DAX(file_inode(file)) && (map_flags & MAP_SYNC))
> +               return -EOPNOTSUPP;

Perhaps EPERM instead to differentiate the unsupported flags case?
There's precedent for mmap returning EPERM for reasons other than
incompatible PROT flags.
