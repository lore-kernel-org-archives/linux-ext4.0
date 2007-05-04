From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and
 powerpc
Date: Thu, 3 May 2007 21:55:28 -0700
Message-ID: <20070503215528.d8ab4e47.akpm@linux-foundation.org>
References: <20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
	<20070417125514.GA7574@amitarora.in.ibm.com>
	<20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070426180332.GA7209@amitarora.in.ibm.com>
	<20070503212955.b1b6443c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070503212955.b1b6443c.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 3 May 2007 21:29:55 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	ret = -EFBIG;
> > +	if (offset + len > inode->i_sb->s_maxbytes)
> > +		goto out_fput;
> 
> This code does handle offset+len going negative, but only by accident, I
> suspect.

But it doesn't handle offset+len wrapping through zero.
