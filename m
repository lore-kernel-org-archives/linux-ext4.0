From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: ext2/3/4: punch support?
Date: Mon, 28 Feb 2011 22:29:56 +0800
Message-ID: <AANLkTimwpoi6agwO4q8qhOcohhSnYFrKhFOCnk0BuTEC@mail.gmail.com>
References: <AANLkTimyu6A=LgF8pit6So6JkPrScFLB42U3NwBJq7mv@mail.gmail.com>
	<20110228131118.GA18193@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110228131118.GA18193@dhcp231-156.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 28, 2011 at 9:11 PM, Josef Bacik <josef@redhat.com> wrote:
> On Mon, Feb 28, 2011 at 03:03:40PM +0800, Dave Young wrote:
>> Hi, josef and ext guys
>>
>> Do you have any plan with ext4 hole punching support? And the
>> fallocate for ext2/3?
>>
>> What's the obstacle to work on this? could someone tell the status o=
f
>> this issue?
>
> There is no obstacle, just nobody has bothered to do it. =C2=A0If you=
 want to do it
> go for it. =C2=A0Thanks,

Yes, I want to do some kvm image space discard stuff,
I use ext4 as my filesystem, but currently only xfs support something
like trim/discard.

I know general knowledge about ext filesystem, but nearly new to ext4 c=
ode,
could you give some hint where to start?

--
Thanks
dave
