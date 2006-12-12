From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Tue, 12 Dec 2006 19:58:27 +0300
Message-ID: <m33b7lcaq4.fsf@bzzz.home.net>
References: <m3vekwtqnp.fsf@bzzz.home.net> <457EDD71.2030909@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:36810 "EHLO gw.home.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932219AbWLLQ7I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Dec 2006 11:59:08 -0500
To: Valerie Clement <valerie.clement@bull.net>
In-Reply-To: <457EDD71.2030909@bull.net> (Valerie Clement's message of "Tue\,
	12 Dec 2006 17\:48\:49 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Valerie Clement (VC) writes:


 VC> The crash occurs because ei->i_locality_group is not well initialized.
 VC> The patch in attachment fixes the problem on my system (x86_64).

thanks!

strange that I didn't hit this on i386 ... and gcc doesn't warn.

thanks, Alex
