From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] quota: fix generic/244 on 32-bit platforms
Date: Mon, 4 Jul 2016 00:26:44 -0500
Message-ID: <b6738cc5-8814-4896-d91a-f2c6e786b6ec@sandeen.net>
References: <1467591116-16880-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1467591116-16880-1-git-send-email-tytso@mit.edu>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 7/3/16 7:11 PM, Theodore Ts'o wrote:
> The test program src/test-nextquota.c relies on atoi() to convert a
> string to an *unsigned* int.  If the string represents an integer
> which is greater than INT_MAX, it is undefined how atoi(3) works, and
> it turns out that:
> 
>        uint id = atoi("2147483649");
> 
> results in id == 2147483649 on x86_64, and id == 2147483647 on a
> 32-bit x86 platform.
> 
> So use strtoul(3) instead, which is portable and technically correct.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: Eric Sandeen <sandeen@redhat.com>

Yup, thanks.  I bet that wasn't fun to track down, sorry.  :(

Though wouldn't it be more correct to cast it to a (uint) ?

But with or without that change this should work with the
test script, so

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

> ---
>  src/test-nextquota.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/src/test-nextquota.c b/src/test-nextquota.c
> index a2bbad9..6eec1f9 100644
> --- a/src/test-nextquota.c
> +++ b/src/test-nextquota.c
> @@ -74,6 +74,7 @@ int main(int argc, char *argv[])
>  	int verbose = 0;
>  	uint id = 0, idflag = 0;
>  	char *device = NULL;
> +	char *tmp;
>  	struct nextdqblk dqb;
>  	struct fs_disk_quota xqb;
>  
> @@ -92,7 +93,11 @@ int main(int argc, char *argv[])
>  			typeflag++;
>  			break;
>  		case 'i':
> -			id = atoi(optarg);
> +			id = (int) strtoul(optarg, &tmp, 0);
> +			if (*tmp) {
> +				fprintf(stderr, "Bad id: %s\n", optarg);
> +				exit(1);
> +			}
>  			idflag++;
>  			break;
>  		case 'd':
> 
