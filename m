From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext2/3/4: punch support?
Date: Mon, 28 Feb 2011 09:17:54 -0600
Message-ID: <4D6BBCA2.8030104@redhat.com>
References: <AANLkTimyu6A=LgF8pit6So6JkPrScFLB42U3NwBJq7mv@mail.gmail.com>	<20110228131118.GA18193@dhcp231-156.rdu.redhat.com> <AANLkTimwpoi6agwO4q8qhOcohhSnYFrKhFOCnk0BuTEC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <josef@redhat.com>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Dave Young <hidave.darkstar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimwpoi6agwO4q8qhOcohhSnYFrKhFOCnk0BuTEC@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2/28/11 8:29 AM, Dave Young wrote:
> On Mon, Feb 28, 2011 at 9:11 PM, Josef Bacik <josef@redhat.com> wrote:
>> On Mon, Feb 28, 2011 at 03:03:40PM +0800, Dave Young wrote:
>>> Hi, josef and ext guys
>>>
>>> Do you have any plan with ext4 hole punching support? And the
>>> fallocate for ext2/3?
>>>
>>> What's the obstacle to work on this? could someone tell the status of
>>> this issue?
>>
>> There is no obstacle, just nobody has bothered to do it.  If you want to do it
>> go for it.  Thanks,
> 
> Yes, I want to do some kvm image space discard stuff,
> I use ext4 as my filesystem, but currently only xfs support something
> like trim/discard.

As Lukas said, ext4 & ext3 support various forms of trim/discard already.

But that's different from punch...

And as for fallocate on ext3, you need somewhere to put the metadata to indicate a block is allocated but not written.  This was a lot more straightforward for ext4, since it describes a large range of blocks with a single extent structure.

-Eric

> I know general knowledge about ext filesystem, but nearly new to ext4 code,
> could you give some hint where to start?
> 
> --
> Thanks
> dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
