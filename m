From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: ext4 still broken on arm (at least)
Date: Wed, 28 Nov 2007 08:28:41 +0000
Message-ID: <20071128082841.GA3006@flint.arm.linux.org.uk>
References: <20071127211444.703741a9.akpm@linux-foundation.org> <20071128053020.GA6977@skywalker> <20071127214308.5215a6a2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-arch@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47368 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbXK1Iiv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Nov 2007 03:38:51 -0500
Content-Disposition: inline
In-Reply-To: <20071127214308.5215a6a2.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 27, 2007 at 09:43:08PM -0800, Andrew Morton wrote:
> On Wed, 28 Nov 2007 11:00:20 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > On Tue, Nov 27, 2007 at 09:14:44PM -0800, Andrew Morton wrote:
> > > fs/ext4/mballoc.c: In function `ext4_mb_generate_buddy':
> > > fs/ext4/mballoc.c:836: error: implicit declaration of function `ext2_find_next_bit'                                                                             
> > 
> > 
> > I actually sent in a patch which changes asking for review to
> > linux-arch. I haven't got the response yet.
> 
> Don't expect one...

Is ext4 merged into the mainline kernel?  So it is...  Okay, I'll
start caring about this patch.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
