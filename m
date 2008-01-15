From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm
 patch]
Date: Tue, 15 Jan 2008 03:04:41 -0800
Message-ID: <20080115030441.a0270609.akpm@linux-foundation.org>
References: <200801140839.01986.abhishekrai@google.com>
	<20080114163412.83a8b18d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Abhishek Rai <abhishekrai@google.com>,
	linux-kernel@vger.kernel.org, rohitseth@google.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbYAOLEb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2008 06:04:31 -0500
In-Reply-To: <20080114163412.83a8b18d.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I'm wondering about the real value of this change, really.

In any decent environment, people will fsck their ext3 filesystems during
planned downtime, and the benefit of reducing that downtime from 6
hours/machine to 2 hours/machine is probably fairly small, given that there
is no service interruption.  (The same applies to desktops and laptops).

Sure, the benefit is not *zero*, but it's small.  Much less than it would
be with ext2.  I mean, the "avoid unplanned fscks" feature is the whole
reason why ext3 has journalling (and boy is that feature expensive during
normal operation).

So...  it's unobvious that the benefit of this feature is worth its risks
and costs?
