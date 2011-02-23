From: Milan Broz <mbroz@redhat.com>
Subject: Re: [opensuse-factory] /sbin/fstrim: /home: FITRIM ioctl failed:
 Operation not supported
Date: Wed, 23 Feb 2011 23:20:57 +0100
Message-ID: <4D658849.2010104@redhat.com>
References: <4D644245.9000809@opensuse.org> <AANLkTi=sMAam8sa-QUxZKzeCev2JWqhc+HnhwC33wgUy@mail.gmail.com> <alpine.LFD.2.00.1102231119580.2934@dhcp-27-109.brq.redhat.com> <4D655C06.2080704@opensuse.org> <alpine.LFD.2.00.1102232117010.2934@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?B?Q3Jpc3RpYW4gUm9kcsOtZ3Vleg==?= <crrodriguez@opensuse.org>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	opensuse-factory <opensuse-factory@opensuse.org>,
	ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1102232117010.2934@dhcp-27-109.brq.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/23/2011 09:18 PM, Lukas Czerner wrote:
>>> Now, there might be some way around this to allow trimming encrypted
>>> volumes without serious security issue, but this is rather question for
>>> dm-crypt guys.
>>
>> Maybe making work the "discard" mount option ?

There were discussion about TRIM on dm-crypt mailing list several times.
one of it is here http://thread.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/4075/ )

Currently TRIM/discard is not intentionally supported on dm-crypt.

Security aspects are obvious (leaking of used blocks at least).

The decision cannot be done in kernel automatically, you can have different
policies, in some situation TRIM of encryption device is not problem,
in other it can be disaster.

So plan is to implement TRIM in dm-crypt but never enable it by default.

You will be able to enable it per-device using device-mapper message
with explicit user request.
(we are using the same message mechanism for wiping/resuming key when
freezing device).

In future this can be flag for LUKS2 metadata but current version of LUKS
doesn't allow such extensions.

Milan
