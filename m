From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH]: e2fsprogs m_* self tests no longer pass
Date: Sat, 19 Mar 2011 16:29:29 -0400
Message-ID: <20110319202929.GA9875@thunk.org>
References: <AANLkTikX2u+tz7e39tb8abRuXtiLDusKpjAf9vZ1tYUU@mail.gmail.com>
 <alpine.LFD.2.00.1103011046240.3874@dhcp-27-109.brq.redhat.com>
 <AANLkTing03byqyWRXbS+AJjHuyZCaJaHczHmVMoW+MBB@mail.gmail.com>
 <F6277800-7506-4613-B9D8-F180191F4ABB@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bruce Cassidy <bruce@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44928 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469Ab1CSU3e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Mar 2011 16:29:34 -0400
Content-Disposition: inline
In-Reply-To: <F6277800-7506-4613-B9D8-F180191F4ABB@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 15, 2011 at 01:50:48PM -0600, Andreas Dilger wrote:
> Only display the "Discarding device blocks:" status bar if discard
> is actually implemented in the IO manager and in the kernel.
> Otherwise, there is no correct test result that will work in all
> environments.  I'd prefer not to print an error message for the
> majority of devices that do not support discard, since this is
> confusing.

I believe this should be fixed already by commit aa07cb79b0, which is
in the e2fsprogs master and next branches.  Can you confirm?

	  	     	  	     	     - Ted
