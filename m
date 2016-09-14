From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: Re: ext4 encrypted dir becomes sickish after 4-5 days
Date: Wed, 14 Sep 2016 19:24:21 +0200
Message-ID: <9cf5b143-7781-30fd-e86a-c78fb088f940@gmx.de>
References: <0951cedc-fff1-682c-daca-b9a1734e43e2@gmx.de>
 <20160914124935.yxfo42bjdlyt2beo@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160914124935.yxfo42bjdlyt2beo@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 09/14/2016 02:49 PM, Theodore Ts'o wrote:
> What does "keyctl list @s" display?  And what hapens if you try to
> rerun the add_key command?  You should see something like this:

# keyctl list @s
1 key in keyring:
 84804552: --alswrv     0 65534 keyring: _uid.0

A rerun of add_key won't help, the output is:

Enter passphrase (echo disabled):
Added key with descriptor [d3b38182555bb6e2]
Added key with descriptor [9d459d03fd3b3adb]
Key with descriptor [9d459d03fd3b3adb] applied to /var/lib/tor.

Accessing the directory works for the user /which has not a login shell):
ssh tfoerste@mr-fox 'sudo -u tor touch /var/lib/tor/foo.bar'

And it doesn't work run add_key for user root.

Furthermore it starts to fail even after 1 or 2 days.
-- 
Toralf
PGP: C4EACDDE 0076E94E, OTR: 420E74C8 30246EE7
