From: Paul Mackerras <paulus@samba.org>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Mon, 23 Feb 2009 21:32:47 +1100
Message-ID: <18850.31567.212454.514549@cargo.ozlabs.ibm.com>
References: <49A2705D.9030008@in.ibm.com>
	<20090223021320.11019d64.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@ucw.cz>, Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linuxppc-dev@ozlabs.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org>
In-Reply-To: <20090223021320.11019d64.akpm@linux-foundation.org>
List-Unsubscribe: <https://ozlabs.org/mailman/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton writes:

> It looks like we died in ext3_xattr_block_get():
> 
> 		memcpy(buffer, bh->b_data + le16_to_cpu(entry->e_value_offs),
> 		       size);
> 
> Perhaps entry->e_value_offs is no good.  I wonder if the filesystem is
> corrupted and this snuck through the defenses.
> 
> I also wonder if there is enough info in that trace for a ppc person to
> be able to determine whether the faulting address is in the source or
> destination of the memcpy() (please)?

It appears to have faulted on a load, implicating the source.  The
address being referenced (0xc00000003f380000) doesn't look
outlandish.  I wonder if this kernel has CONFIG_DEBUG_PAGEALLOC turned
on, and what page size is selected?

Paul.
