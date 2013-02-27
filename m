From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 corruption on Linus latest tree.
Date: Wed, 27 Feb 2013 13:03:02 -0500
Message-ID: <20130227180302.GB16966@thunk.org>
References: <20130227154311.GA12450@redhat.com>
 <20130227155539.GA2638@pd.tnic>
 <20130227160446.GA4792@redhat.com>
 <20130227164417.GF5609@thunk.org>
 <20130227165621.GA8834@redhat.com>
 <3F9FDA73-A142-43FB-BFF2-35C200355736@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3F9FDA73-A142-43FB-BFF2-35C200355736@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 28, 2013 at 01:07:10AM +0800, gnehzuil.liu wrote:
> 
> Thanks for the report.  From the result, I think extent status tree
> is root cause because of wrong logical-to-physical block mapping.  I
> am very sorry about that.  I will try to fix the bug ASAP.

Here's a hint as to what's going on:

% bc
bc 1.06.95
Copyright 1991-1994, 1997, 1998, 2000, 2004, 2006 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'. 
obase=16
# This is the block number printed in the error message
152052301
910224D

# This is the block number reported by debugfs
688923213
2910224D

It looks like something in the code is masking off the low 25 bits, so
we're losing the higher bits from the physical block number.  That
should be pretty easy to find and fix....

       	  	      	      	  - Ted
