From: Theodore Tso <tytso@mit.edu>
Subject: [cebbert@redhat.com: Re: Ext4 tree backports for 2.6.27.13 and
	2.6.28.2]
Date: Mon, 16 Feb 2009 18:01:04 -0500
Message-ID: <20090216230104.GG23758@mini-me.lan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48681 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZBPXkK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Feb 2009 18:40:10 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Can you please include the patches found in the for-stable and
for-stable-2.6.27 branches at:

	  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git

into the next 2.6.28.y and 2.6.27.y kernels, respectively?

Or do you need me to send them in e-mail format via git
format-patch/git send-email?  I can do that too if you prefer that.

		 	      	       - Ted




--J2SCkAp4GZ/dPZZf
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <cebbert@redhat.com>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Mon, 16 Feb 2009 16:37:49 -0500
X-Sieve: CMU Sieve 2.2
Received: from fort-point-station.mit.edu by po14.mit.edu (8.13.6/4.7) id n1GLbmDm014461; Mon, 16 Feb 2009 16:37:48 -0500 (EST)
Received: from mit.edu (M24-004-BARRACUDA-1.MIT.EDU [18.7.7.111])
	by fort-point-station.mit.edu (8.13.6/8.9.2) with ESMTP id n1GLbhLi004836
	for <tytso@mit.edu>; Mon, 16 Feb 2009 16:37:43 -0500 (EST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31])
	by mit.edu (Spam Firewall) with ESMTP id 33E14D647FE
	for <tytso@mit.edu>; Mon, 16 Feb 2009 16:37:41 -0500 (EST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n1GLbe2q016841;
	Mon, 16 Feb 2009 16:37:40 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1GLbeWP020811;
	Mon, 16 Feb 2009 16:37:40 -0500
Received: from dhcp-100-2-144.bos.redhat.com (dhcp-100-2-144.bos.redhat.com [10.16.2.144])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n1GLbdYC016657;
	Mon, 16 Feb 2009 16:37:39 -0500
Date: Mon, 16 Feb 2009 16:35:07 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Message-ID: <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20090212211935.GE6922@mini-me.lan>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
	<20090211075914.GC20842@skywalker>
	<20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com>
	<20090212211935.GE6922@mini-me.lan>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.42
X-Scanned-By: MIMEDefang 2.58 on 172.16.27.26
X-Spam-Score: 0.00
X-Spam-Flag: NO

On Thu, 12 Feb 2009 16:19:35 -0500
Theodore Tso <tytso@mit.edu> wrote:

> 
> I've updated the for-stable and for-stable-2.6.27 branches against the
> latest stable releases, and I've updated the two flawed backports in
> the for-stable-2.6.27 branch.  Could you do a quick double-check and
> make sure the fixes are as you expect, before I send a pull request to
> stable@kernel.org?

The 2.6.27 branch looks good to me.

--J2SCkAp4GZ/dPZZf--
