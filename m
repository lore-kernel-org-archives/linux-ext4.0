From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] misc: Allow "-E" and "-O" options multiple times
Date: Sun, 10 Jul 2011 16:46:33 -0400
Message-ID: <20110710204633.GB5615@thunk.org>
References: <1310172544-18650-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jim Garlick <garlick@llnl.gov>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46892 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab1GJUqi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2011 16:46:38 -0400
Content-Disposition: inline
In-Reply-To: <1310172544-18650-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 08, 2011 at 06:49:03PM -0600, Andreas Dilger wrote:
> Allow "-E" and "-O" options to be specified multiple times on the
> command-line for mke2fs, tune2fs, and e2fsck, and parse them after
> the config file options to more closely match user expectations.

Well, we're doing that already for mke2fs.  As far as e2fsck is
concerned....

> @@ -883,14 +888,15 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
>  			argv[optind]);
>  		fatal_error(ctx, 0);
>  	}
> -	if (extended_opts)
> -		parse_extended_opts(ctx, extended_opts);
>  
>  	if ((cp = getenv("E2FSCK_CONFIG")) != NULL)
>  		config_fn[0] = cp;
>  	profile_set_syntax_err_cb(syntax_err_report);
>  	profile_init(config_fn, &ctx->profile);
>  
> +	if (extended_opts)
> +		parse_extended_opts(ctx, extended_opts);
> +
>  	if (flush) {
>  		fd = open(ctx->filesystem_name, O_RDONLY, 0);
>  		if (fd < 0) {

Merely moving parse_extended_opts to after profile_init() doesn't
actually do anything.  All profile_init() does is to parse the
configuration file and load it into memory in a format where it can be
quickly and easily fetched via profile_get_{bool,string,int}().

If you want the command line options to override what is specified in
the config file, you have one of two options:

1)  Call profile_get_{bool,string,int}() and stash the result in a
variable, and then call parse_extended_opts(), and have that function
modify the configuration variable.

2) Have parse_extended_opts() modify a configuration variable, and
then if the configuration variable is set, then at the place in the
code where profile_get_{bool,string,int}() is called, don't call the
profile_get_* function.

In general, #1, is the better choice, but moving parse_extended_opts()
above is pointless.

							- Ted
