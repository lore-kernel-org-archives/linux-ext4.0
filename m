From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Directories > 2GB
Date: Tue, 10 Oct 2006 10:19:04 +0100
Message-ID: <20061010091904.GA395@infradead.org>
References: <20061004165655.GD22010@schatzie.adilger.int> <452AC4BE.6090905@xfs.org> <20061010015512.GQ11034@melbourne.sgi.com> <452B0240.60203@xfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:26513 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965125AbWJJJTK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Oct 2006 05:19:10 -0400
To: Steve Lord <lord@xfs.org>
Content-Disposition: inline
In-Reply-To: <452B0240.60203@xfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 09, 2006 at 09:15:28PM -0500, Steve Lord wrote:
> Hi Dave,
> 
> My recollection is that it used to default to on, it was disabled
> because it needs to map the buffer into a single contiguous chunk
> of kernel memory. This was placing a lot of pressure on the memory
> remapping code, so we made it not default to on as reworking the
> code to deal with non contig memory was looking like a major
> effort.

Exactly.  The code works but tends to go OOM pretty fast at least
when the dir blocksize code is bigger than the page size.  I should
give the code a spin on my ppc box with 64k pages if it works better
there.

