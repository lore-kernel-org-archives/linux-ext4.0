From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] fix an endianness bug in ext4_encrypted_follow_link()
Date: Thu, 26 Nov 2015 11:40:37 -0800
Message-ID: <1448566837.18647.16.camel@perches.com>
References: <20151126152728.GT22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>,
	Julia Lawall <julia.lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151126152728.GT22011@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

(cc'ing Julia Lawall)

On Thu, 2015-11-26 at 15:27 +0000, Al Viro wrote:
> applying le32_to_cpu() to 16bit value is a bad idea...

Julia, perhaps you or your crew could produce a coccinelle test
for this class of error?

> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index abe2401..e8e7af6 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -52,7 +52,7 @@ static const char *ext4_encrypted_follow_link(struct dentry *dentry, void **cook
>  	/* Symlink is encrypted */
>  	sd = (struct ext4_encrypted_symlink_data *)caddr;
>  	cstr.name = sd->encrypted_path;
> -	cstr.len  = le32_to_cpu(sd->len);
> +	cstr.len  = le16_to_cpu(sd->len);
>  	if ((cstr.len +
>  	     sizeof(struct ext4_encrypted_symlink_data) - 1) >
>  	    max_size) {
