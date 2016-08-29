From: Pavel Machek <pavel@ucw.cz>
Subject: ext4 encryption trap
Date: Mon, 29 Aug 2016 12:08:16 +0200
Message-ID: <20160829100816.GA14524@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58104 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756860AbcH2KIU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Aug 2016 06:08:20 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

You encrypt a directory -- sounds easy, right? Support is in 4.4
kernel, my machines run newer kernels than that. Encrypting root would
be hard, but encrypting parts of data partition should be easy.

Ok, lets follow howto... Need to do tune2fs. Right. Aha, still does
not work, looks like I'll need to reboot.

Hmm. Will not boot. Grub no longer recognizes my /data partition, and
that's where new kernels are. Old kernels are in /boot, but those are
now useless. Lets copy new kernel on machine using USB stick. Does not
boot. Fun.

tune2fs on root filesystem is useless, as it is too old. New one
is ... on the data partition. Right. Ok, lets bring newer version of
tune2fs in. "encryption" feature can not be cleared.

Argh! Come on, I did not even create single encrypted directory on the
partition. I want the damn bit to go off, so I can go back to working
configuration. "Old kernels can not read encrypted files" sounds ok,
but "old kernels can not mount filesystem at all" is not acceptable
here :-(.

Is there way to go back? Restoring 400GB from backups would not be fun
:-(.

On a related note, would it be possible to return some kind of error
when encrypted directory is accessed without available keys? I use
unison for backups/sync, and if I ever make a mistake of trying to
sync in non-decrypted state, results would be very very bad...

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
