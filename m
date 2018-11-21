Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33592 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbeKUP1z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 10:27:55 -0500
Date: Tue, 20 Nov 2018 23:55:03 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 4/9] mke2fs: Configure encoding during
 superblock initialization
Message-ID: <20181121045503.GA26006@thunk.org>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
 <20181015211220.27370-5-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015211220.27370-5-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2018 at 05:12:15PM -0400, Gabriel Krisman Bertazi wrote:
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index f05003fc30b9..5ed7b987540e 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -790,6 +790,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
>  	int	len;
>  	int	r_usage = 0;
>  	int	ret;
> +	int	encoding = -1;
> +	char 	*encoding_flags = NULL;

    ...

> +	if (ext2fs_has_feature_fname_encoding(param)) {
> +		param->s_encoding_flags =
> +			ext4_encoding_map[encoding].default_flags;

This code is assuming that users will specify the encoding via "-E encoding=utf8-10.0"
and this will set the FNAME_ENCODING flag implicitly.

But consider what happens if the user runs command like this:

    mke2fs -t ext4 -O fname_encoding -E resize=12T

When parse_extended_opts gets called, the variable encoding will still
be -1, and so we'll end up trying to use a negative array index to
ext4_encoding_map[] which will be... unfortunate.

As I mentioned in another e-mail, I'm a bit dubious about having
per-encoding default flags.  Those flags should either global ext4
code points, or they should be forced to specific values given the
encoding that is specified.
 
We probably also want to have a default encoding if the user just
specifies "-O fname_encoding".   Say, in /etc/mke2fs.conf:

[options]
    default_encoding = utf8-11.0

Then at some point a few years from now, we might enable
fname_encoding by default, so we might have in /etc/mke2fs.conf:

[fs_types]
	ext4 = {
		features = has_journal,extent,huge_file,flex_bg,metadata_csum,64bit,dir_nlink,extra_isize,largedir,fname_encoding
		inode_size = 256
	}

So having a way to specify the default encoding in /etc/mke2fs.conf is
going to be important.  What will probably happen is two years, we'll
be up to Unicode 13.0, and we might want to add support for Unicode
13.0 in some future kernel version,, say, 5.8.  But then we won't want
to make utf8-13.0 the default for some amount of time, since if the
file system is mounted on an older kernel, it won't work; the kernel
will have to reject mounting a file system with an unknown encoding.

So that's why I always like to make these sorts of configuration
defaults to be tuneable in /etc/mke2fs.conf.  Different distros will
have different backwards compatibility policies.  For example, For
enterprise distros, they might want to wait 7 years before creating
file systems with utf8-13.0 as the default.  For a community distro,
they might want to wait 2-3 years.  And for a purpose-built Linux
gaming Valve box, where the kernel is under the control of the box
manufacturers, they might want to be super-aggressive about adopting a
new Unicode encoding, in order to crack that critical Ancient Sanskrit
market.  :-)

						- Ted
