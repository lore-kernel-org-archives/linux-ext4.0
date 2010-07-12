From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] Cleancache: shim to Xen Transcendent Memory
Date: Mon, 12 Jul 2010 11:05:22 -0400
Message-ID: <20100712150522.GD5358@phenom.dumpdata.com>
References: <20100708164208.GA11763@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org,
	jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com,
	npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com,
	avi@redhat.com
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:31416 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab0GLPGu (ORCPT
	<rfc822;<linux-ext4@vger.kernel.org>>);
	Mon, 12 Jul 2010 11:06:50 -0400
Content-Disposition: inline
In-Reply-To: <20100708164208.GA11763@ca-server1.us.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 08, 2010 at 09:42:08AM -0700, Dan Magenheimer wrote:
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

One nitpick:
..
> +
> +int tmem_enabled;
> +
> +static int __init enable_tmem(char *s)
> +{
> +	tmem_enabled = 1;
> +	return 1;
> +}
> +
> +__setup("tmem", enable_tmem);

Perhaps 'tmem_setup' is more appropiate as it might be that this
function in the future would be only used to disable tmem, not actually
enable it?

Otherwise, it has been reviewed by me.
