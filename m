From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/10 v3] ext4: add physical block and status member into
 extent status tree
Date: Sat, 2 Feb 2013 22:03:43 -0500
Message-ID: <20130203030343.GB1359@thunk.org>
References: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
 <1358942640-2262-4-git-send-email-wenqing.lz@taobao.com>
 <20130129030353.GK7003@thunk.org>
 <20130129053415.GA27002@gmail.com>
 <20130129172814.GC4261@thunk.org>
 <20130130024332.GA12111@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christopher Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org
To: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46677 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab3BCDDy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Feb 2013 22:03:54 -0500
Content-Disposition: inline
In-Reply-To: <20130130024332.GA12111@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 30, 2013 at 10:43:33AM +0800, Zheng Liu wrote:
> 
> Clang is first coming in my mind.  I know that some one try to use it
> to build a linux kernel and get a lot of problems that are about gcc
> extension.  But for us it seems that things are not too bad. ;)

Clang accepts bitfields with "unsigned long long", but I've discovered
something which does _not_ support unsigned long long --- the "sparse"
tool.  :-(

I discovered this when running "make C=1", i.e.:

  rm -f fs/ext4/extents_status.o
  make C=1 fs/ext4/extents_status.o

Here's a simple test case which demo's that sparse doesn't deal well
with unsigned long long.  If we change the last two fields in struct
extents_status to:

	unsigned long es_pblk : 30;	/* first physical block */
	unsigned long es_status : 2;	/* record the status of extent */

sparse doesn't complain.  But as shown below, sparse complains bitterly:

/tmp/foo.c:22:24: warning: invalid access past the end of 'es' (24 28)

I'm not sure Chris will consider this a bug, since bitfields
with "unsigned long long" isn't standards complaint, even if gcc and
clang supports it.   Chris, what do you think?

              	       		      	       - Ted
   	

#!/bin/sh
cat > /tmp/foo.c << EOF
#include <unistd.h>
#include <stdio.h>

struct rb_node {
	unsigned long  __rb_parent_color;
	struct rb_node *rb_right;
	struct rb_node *rb_left;
} __attribute__((aligned(sizeof(long))));

struct extent_status {
	struct rb_node rb_node;
	unsigned long es_lblk;		/* first logical block extent covers */
	unsigned long es_len;		/* length of extent in block */
	unsigned long long es_pblk : 62;	/* first physical block */
	unsigned long long es_status : 2;	/* record the status of extent */
};

int main(int argc, char **argv)
{
	struct extent_status es;

	es.es_status = 3;

	printf("%d\n", es.es_status);
	printf("size %u\n", sizeof(es));
}
EOF
sparse /tmp/foo.c
