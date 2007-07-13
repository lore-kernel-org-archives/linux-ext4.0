From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/6][TAKE7] manpage for fallocate
Date: Sat, 14 Jul 2007 00:06:51 +1000
Message-ID: <20070713140651.GO31489@sgi.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124601.GA22961@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	michael.kerrisk@gmx.net, tytso@mit.edu, cmm@us.ibm.com,
	suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070713124601.GA22961@amitarora.in.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 13, 2007 at 06:16:01PM +0530, Amit K. Arora wrote:
> Following is the modified version of the manpage originally submitted by
> David Chinner. Please use `nroff -man fallocate.2 | less` to view.
> 
> This includes changes suggested by Heikki Orsila and Barry Naujok.

Can we get itemised change logs for all these patches from now on?

> .TH fallocate 2
> .SH NAME
> fallocate \- allocate or remove file space

If fallocate is just being used for allocating space this is wrong.
maybe - "manipulate file space" instead?

dd> .TP
> .B FALLOC_RESV_SPACE
> provides the same functionality as
> .B FALLOC_ALLOCATE
> except it does not ever change the file size. This allows allocation
> of zero blocks beyond the end of file and is useful for optimising

"of zeroed blocks"

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
