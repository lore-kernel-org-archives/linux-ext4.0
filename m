From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH, RFC] ext4: Store basic fs error information in the superblock
Date: Thu, 24 Jun 2010 16:44:42 +0200
Message-ID: <87sk4c8p7p.fsf@basil.nowhere.org>
References: <1277349714-9697-1-git-send-email-tytso@mit.edu>
	<871vbw8zzi.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:55790 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab0FXOor (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2010 10:44:47 -0400
In-Reply-To: <871vbw8zzi.fsf@dmon-lap.sw.ru> (Dmitry Monakhov's message of
	"Thu, 24 Jun 2010 14:52:01 +0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:
>> bother to send them along.
> Excellent choice. s_error_XXX fields finally allow one to detect errors
> in determinant meaner. And most stress test finally will do it after
> umount :).

 ... assuming you can still write the super block after the error.
-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
