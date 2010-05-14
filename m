From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Cleancache [PATCH 2/7] (was Transcendent Memory): core files
Date: Sat, 15 May 2010 00:18:15 +0100
Message-ID: <20100514231815.GY30031@ZenIV.linux.org.uk>
References: <20100422132809.GA27302@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, akpm@linux-foundation.org, adilger@sun.com,
	tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
	matthew@wil.cx, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org,
	JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
	dave.mccracken@oracle.com, riel@redhat.com
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100422132809.GA27302@ca-server1.us.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 22, 2010 at 06:28:09AM -0700, Dan Magenheimer wrote:
> +struct cleancache_ops {
> +	int (*init_fs)(unsigned long);

unsigned long?  Really?  Not even size_t?

> +	int (*init_shared_fs)(char *uuid, unsigned long);

Ditto.

> +	int (*get_page)(int, unsigned long, unsigned long, struct page *);

Ugh.  First of all, presumably you have some structure behind that index,
don't you?  Might be a better way to do it.

What's more, use of ->i_ino is simply wrong.  How stable do you want that
to be and how much do you want it to outlive struct address_space in question?
>From my reading of your code, it doesn't outlive that anyway, so...

The third one is pgoff_t; again, use sane types, _if_ you actually want
the argument #3 at all - it can be derived from struct page you are passing
there as well.

> +	int (*put_page)(int, unsigned long, unsigned long, struct page *);
> +	int (*flush_page)(int, unsigned long, unsigned long);
> +	int (*flush_inode)(int, unsigned long);
> +	void (*flush_fs)(int);

Same questions as above...
