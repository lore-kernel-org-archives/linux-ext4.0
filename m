From: Matthias Dahl <ml_linux-kernel@binary-island.eu>
Subject: state of ext4 encryption
Date: Wed, 13 Jul 2016 20:40:42 +0200
Message-ID: <d938b36d643ed1a14a7c9dead66cbd30@mail.ud19.udmedia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ud19.udmedia.de ([194.117.254.59]:45472 "EHLO
	mail.ud19.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbcGMSrb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jul 2016 14:47:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I am currently setting up a new machine and I am looking into encryption
to be able to better deal with faulty disks (e.g. sending them in for
warranty or throwing them away) without having to worry that private
and/or business data is still readable to anyone when wiping them is no
longer possible (e.g. defects, relocated sectors, ...).

So, dm-crypt is causing me some unfortunate headaches at this point and
thus I am considering the ext4 fs encryption.

To make a long story short: I could not find any recent updates on what
state it is currently considered to be in? Is it ready to be used or is
it still too early?

I heard rumors that Android N will possibly already replace dm-crypt w/
ext4's fs encryption? Is that true? That would naturally show quite a
sign of confidence. ;-)

And last but not least: I guess full fs encryption (as-in: everything
from the root down) will be rather problematic?

Since I currently have to make do with a crappy webmail interface until
I have the new machine up, I am not subscribed to the list and would ask
to be cc'd.

Thanks,
Matthias

-- 
Dipl.-Inf. (FH) Matthias Dahl | Software Engineer | binary-island.eu
  services: custom software [desktop, mobile, web], server administration
