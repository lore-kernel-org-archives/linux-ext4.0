From: "Joseph D. Wagner" <joe@josephdwagner.info>
Subject: Re: ext4 file replace guarantees
Date: Fri, 21 Jun 2013 09:25:13 -0700
Message-ID: <bf675d01f2290be4e38f602ce78643c9@josephdwagner.info>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, Ryan Lortie <desrt@desrt.ca>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from josephdwagner.info ([72.4.161.242]:57928 "EHLO
	josephdwagner.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423148Ab3FUQYO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jun 2013 12:24:14 -0400
In-Reply-To: <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I want to know that either the old data will be there, or the new
> data.

Ted,

Please forgive me for the stupid question.  Would Ryan's concerns be
addressed by configuring ext4 to run in data=journal mode?

I realize that as a programmer he cannot guarantee that his application
will run on a file system in a particular configuration.  I'm just
curious as to how this all fits together.

Joseph D. Wagner
