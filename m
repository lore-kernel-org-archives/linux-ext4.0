From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] shared/289: do not special-case ext3
Date: Mon, 27 Apr 2015 10:18:35 -0500
Message-ID: <553E534B.5000805@redhat.com>
References: <1430134449-16060-1-git-send-email-eguan@redhat.com>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1430134449-16060-1-git-send-email-eguan@redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 4/27/15 6:34 AM, Eryu Guan wrote:
> Commit "3574531 xfstests: count journal size in test 289" makes ext3 a
> special case, but now it's not the case anymore after kernel commit
> 
> e6d8fb3 ext3: Count internal journal as bsddf overhead in ext3_statfs
> 
> So just remove the special case, now test passes on both ext3 and ext4,
> also ext3 driven by ext4 module.

I think perhaps it was actually:

2046fd1 ext3: Count journal as bsddf overhead in ext3_statfs

(in v3.13) which changed the behavior; the commit you mention only
removes the overhead again for external journals, but your change
below looks fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


.> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/shared/289 | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/tests/shared/289 b/tests/shared/289
> index c53d38c..96c949d 100755
> --- a/tests/shared/289
> +++ b/tests/shared/289
> @@ -58,18 +58,7 @@ TOTAL_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
>  FREE_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
>  		| awk '/Free blocks:/{print $3}'`
>  
> -# ext3 doesn't count journal blocks as overhead, ext4 does.
> -if [ $FSTYP = "ext3" ]; then
> -	JOURNAL_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> -		| awk '/Journal size:/{print $3}' | _filter_size_to_bytes`
> -	BLOCK_SIZE=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
> -		| awk '/Block size:/{print $3}'`
> -	JOURNAL_BLOCKS=$(($JOURNAL_SIZE/$BLOCK_SIZE))
> -else
> -	JOURNAL_BLOCKS=0
> -fi
> -
> -OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS-$JOURNAL_BLOCKS))
> +OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS))
>  
>  #  bsddf|minixdf
>  #         Set the behaviour  for  the  statfs  system  call.  The  minixdf
> 
