From: Benno Schulenberg <bensberg@justemail.net>
Subject: Re: [2/4 v2] e2fsck: make a prompt message simpler and thus translatable
Date: Wed, 04 Jun 2014 17:38:12 +0200
Message-ID: <1401896292.29436.125136989.78578825@webmail.messagingengine.com>
References: <20140602234001.GJ30598@thunk.org>
 <1401827722-13286-1-git-send-email-bensberg@justemail.net>
 <20140604020719.GC27426@thunk.org>
 <1401884601.6870.125052445.0CA47507@webmail.messagingengine.com>
 <20140604125650.GF27426@thunk.org>
 <1401888336.22807.125078021.186DE367@webmail.messagingengine.com>
 <20140604144239.GI27426@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38071 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627AbaFDPiN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2014 11:38:13 -0400
In-Reply-To: <20140604144239.GI27426@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, Jun 4, 2014, at 16:42, Theodore Ts'o wrote:
> So it looks like allowing the placement of the XXX characters in the
> middle of the filename is a GNU coreutils extension, and it must have
> been introduced very shortly after Ubuntu 10.04 snapshotted its
> coreutils package from Debian.

You are right.  On Wed Nov 4 2009 there is this in coreutils' git:

-TEMPLATE must end in at least 3 consecutive `X's.\n\
+TEMPLATE must contain at least 3 consecutive `X's in last component.\n\

and:

-count_trailing_X_s (const char *s)
+count_consecutive_X_s (const char *s, size_t len)

So, you can probably drop the patch.

Benno

-- 
http://www.fastmail.fm - One of many happy users:
  http://www.fastmail.fm/help/overview_quotes.html

