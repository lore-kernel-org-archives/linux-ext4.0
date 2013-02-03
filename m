From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/10 v3] ext4: add physical block and status member into
 extent status tree
Date: Sun, 3 Feb 2013 09:57:42 -0500
Message-ID: <20130203145742.GA5424@thunk.org>
References: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
 <1358942640-2262-4-git-send-email-wenqing.lz@taobao.com>
 <20130129030353.GK7003@thunk.org>
 <20130129053415.GA27002@gmail.com>
 <20130129172814.GC4261@thunk.org>
 <20130130024332.GA12111@gmail.com>
 <20130203030343.GB1359@thunk.org>
 <20130203052113.GA9823@gmail.com>
 <20130203081943.GF4937@mwanda>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Christopher Li <sparse@chrisli.org>,
	linux-sparse@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46772 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab3BCO5u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:50 -0500
Content-Disposition: inline
In-Reply-To: <20130203081943.GF4937@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 03, 2013 at 11:19:43AM +0300, Dan Carpenter wrote:
> 
> I don't get this warning on my version of Sparse.
> 
> Sparse used to assume -m32 all the time but now that's been changed.
> Are you using the most recent version of Sparse?  Try passing -m64.

Hmm, I got my version of sparse from

git://git.kernel.org/pub/scm/devel/sparse/sparse.git

... where the latest version is 0.4.4, dated November 21, 2011.  Is
there a different dit repository I should be using?

I see that it doesn't complain with -m64, but the test program should
be valid for x86 with 32 bits just as much as 64 bits.  Am I missing
something?

						- Ted


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=testcase

#!/bin/sh
cat > /tmp/testcase.c << EOF
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
echo "sparse /tmp/testcase.c"
sparse /tmp/testcase.c
echo " "
echo "sparse -m32 /tmp/testcase.c"
sparse -m32 /tmp/testcase.c
echo " "
echo "sparse -m64 /tmp/testcase.c"
sparse -m64 /tmp/testcase.c



--HcAYCG3uE/tztfnV--
