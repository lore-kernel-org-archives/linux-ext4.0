From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: Set barrier=0 when block device does not advertise
 flush support
Date: Fri, 3 Dec 2010 02:09:50 -0500
Message-ID: <20101203070950.GA19071@infradead.org>
References: <20101203001659.GI18195@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101203001659.GI18195@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 02, 2010 at 04:16:59PM -0800, Darrick J. Wong wrote:
> If the user tries to enable write flushes with "barrier=1" and the underlying
> block device does not support flushes, print a message and set barrier=0.

That doesn't make any sense at all with the ne wFLUSH+FUA code, which is
designed to make the cache flushing entirely transparanent.  Basically
with the new code the barrier option should become a no-op and always
enabled.
