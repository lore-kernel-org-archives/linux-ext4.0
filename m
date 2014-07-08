From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: clarify ext4_error message in
 ext4_mb_generate_buddy_error()
Date: Tue, 8 Jul 2014 09:03:48 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407080855520.2180@localhost.localdomain>
References: <1404602162-16730-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1404602162-16730-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 5 Jul 2014, Theodore Ts'o wrote:

> Date: Sat,  5 Jul 2014 19:16:02 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
> Subject: [PATCH] ext4: clarify ext4_error message in
>     ext4_mb_generate_buddy_error()
> 
> We are spending a lot of time explaining to users what this error
> means.  Let's try to improve the message to avoid this problem.

It is a bit better, even though strictly speaking it's not
right, because it is not block bitmap alone, but rather aggregation
of block bitmap and preallocations. But for the user this is really
an implementation detail they do not need to worry about I guess.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!
-Lukas

> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/mballoc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 7f72f50..2dcb936 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -752,8 +752,8 @@ void ext4_mb_generate_buddy(struct super_block *sb,
>  
>  	if (free != grp->bb_free) {
>  		ext4_grp_locked_error(sb, group, 0, 0,
> -				      "%u clusters in bitmap, %u in gd; "
> -				      "block bitmap corrupt.",
> +				      "block bitmap and bg descriptor "
> +				      "inconsistent: %u vs %u free clusters",
>  				      free, grp->bb_free);
>  		/*
>  		 * If we intend to continue, we consider group descriptor
> 
