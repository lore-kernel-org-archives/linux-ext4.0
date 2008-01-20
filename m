From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm patch]
Date: Sat, 19 Jan 2008 19:55:41 -0800
Message-ID: <200801191955.41980.phillips@phunq.net>
References: <200801140839.01986.abhishekrai@google.com> <20080114163412.83a8b18d.akpm@linux-foundation.org> <20080115030441.a0270609.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Abhishek Rai <abhishekrai@google.com>,
	linux-kernel@vger.kernel.org, rohitseth@google.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758655AbYATD4B@vger.kernel.org>
In-Reply-To: <20080115030441.a0270609.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 15 January 2008 03:04, Andrew Morton wrote:
> I'm wondering about the real value of this change, really.
>
> In any decent environment, people will fsck their ext3 filesystems
> during planned downtime, and the benefit of reducing that downtime
> from 6 hours/machine to 2 hours/machine is probably fairly small,
> given that there is no service interruption.  (The same applies to
> desktops and laptops).
>
> Sure, the benefit is not *zero*, but it's small.  Much less than it
> would be with ext2.  I mean, the "avoid unplanned fscks" feature is
> the whole reason why ext3 has journalling (and boy is that feature
> expensive during normal operation).
>
> So...  it's unobvious that the benefit of this feature is worth its
> risks and costs?

Since I am waiting for an Ext3 fsck to complete right now, I thought I 
would while away the time by tagging on my "me too" to the concensus 
that faster fsck is indeed worth the cost, which is (ahem) free.

Regards,

Daniel
