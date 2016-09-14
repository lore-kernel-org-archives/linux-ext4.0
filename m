From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: ext4 encrypted dir becomes sickish after 4-5 days
Date: Wed, 14 Sep 2016 11:44:02 +0200
Message-ID: <0951cedc-fff1-682c-daca-b9a1734e43e2@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I do run a hardened stable Gentoo Linux server w/ kernel 4.7.3-ahrdened-r1 where I use an ext4fs directory /var/lib/tor in the following way :

	scp ~/.cryptoSalt user@host:/tmp
	cat /tmp/.cryptoPass | ssh user@host 'sudo -u tor e4crypt add_key -S $(cat /tmp/.cryptoSalt) /var/lib/tor && sudo /etc/init.d/tor start; rm /tmp/.cryptoSalt'

Works fine after reboot.

But after 4 days or so a restart of the service "tor" fails with messages like :

Sep 14 11:27:10.000 [warn] Could not open "/var/lib/tor/data/keys/secret_id_key": Required key not available
Sep 14 11:27:10.000 [warn] Error reading private key from "/var/lib/tor/data/keys/secret_id_key"
Sep 14 11:27:10.000 [err] Error loading private key.
Sep 14 11:27:10.000 [err] Error initializing keys; exiting
Sep 14 11:27:10.000 [warn] Couldn't open "/var/lib/tor/data/state.tmp" (/var/lib/tor/data/state) for writing: Required key not available
Sep 14 11:27:10.000 [warn] Unable to write state to file "/var/lib/tor/data/state"; will try again later

No way to get it repaired other than rebooting the machine.

Any hints  ?

-- 
Toralf
PGP: C4EACDDE 0076E94E, OTR: 420E74C8 30246EE7
