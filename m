From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 10/10] Fs: ext4: namei: fixed file of checkpatch/pl warnings and errors
Date: Sun, 26 Sep 2010 21:17:20 +0200
Message-ID: <m38w2o48n3.fsf@intrepid.localdomain>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	<1285439521-2557-10-git-send-email-tdent48227@gmail.com>
	<m3pqw16mfh.fsf@intrepid.localdomain>
	<20100926182338.GM19690@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tracey Dent <tdent48227@gmail.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:34259 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab0IZTRX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Sep 2010 15:17:23 -0400
In-Reply-To: <20100926182338.GM19690@thunk.org> (Ted Ts'o's message of "Sun,
	26 Sep 2010 14:23:38 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o <tytso@mit.edu> writes:

> I'm beginning to think we need to have an entry in the kernel newbie's
> FAQ warning people that the output of various scripts such as
> checkpatch and get_maintainer are not authoratative, and are
> hueristics intended to be supplemented by human intelligence.

Definitely.

Current situation creates some false impressions, leaving the newcomers
confused (at best). Net effect = loss.
-- 
Krzysztof Halasa
