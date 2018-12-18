Return-Path: <SRS0=0j4F=O3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from dmz-mailsec-scanner-1.mit.edu ([18.9.25.12]:58972 "EHLO
        dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727540AbeLRQnP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Dec 2018 11:43:15 -0500
Date: Tue, 18 Dec 2018 11:35:39 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: avoid declaring fs inconsistent due to invalid
 file handles
Message-ID: <20181218163539.GC25775@mit.edu>
References: <20181213175107.29464-1-tytso@mit.edu>
 <A3D72248-487E-412E-B341-7450C773E81F@dilger.ca>
 <20181218044541.GB25775@mit.edu>
 <F169A778-5219-4FDD-8899-3074DFFDD8A4@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F169A778-5219-4FDD-8899-3074DFFDD8A4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 17, 2018 at 10:43:40PM -0700, Andreas Dilger wrote:
> I don't think that it is verboten to use binary flag values in an enum,
> if you explicitly specify the values, which is why I used "0x01", "0x02"
> to make it more clear these are binary values.  IMHO, using a named enum
> is a good way to annotate the function parameters rather than a generic
> "int flag" parameter that is ambiguous unless you look at the function
> code to see what the values of "flag" might be.

I tend to only use enums in this kind of way:

enum classification_levels { 
	FOR_OFFICIAL_USE_ONLY, 
	CONFIDENTIAL,
	SECRET, 
	TOP_SECRET, 
};

I think the reason why I've never used it for type checking is because
for gcc and sparse, it doesn't work.  For the below example, "gcc
-Wall foo.c" won't complain at all.  Sparse complains only about the
"return a | b;" line, because we're combining two different enum
types.  Sparse doesn't say boo that I passed EXT4_IGET_NORMAL where a
classification_levels, and secret where an ext4_iget_flags is
expected:

enum ext4_iget_flags {
	EXT4_IGET_RESERVED = 0x00,    /* just guessing, see further below */
	EXT4_IGET_NORMAL   = 0x01,
	EXT4_IGET_HANDLE   = 0x02
};

int combine(enum classification_levels a, enum ext4_iget_flags b)
{
	return a | b;
}


int main(int argc, char **argv)
{
	printf("%d\n", combine(EXT4_IGET_NORMAL, secret));
	exit(1);
}
	
Then again, llvm does correctly complain, and at least for Android
configs, llvm will complain kernels correctly (although I'm not sure
enterprise distros trust LLVM just yet), and I do agree that it's
useful from a documentation perspective.

Cheers,

					- Ted
