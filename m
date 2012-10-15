From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v3 13/13] vfs: add documentation
Date: Mon, 15 Oct 2012 15:04:32 +0800
Message-ID: <CAEH94Ljr0MOgpgW1gtFpTbMsRHnTZM4afFOBCnTo42hC4W6r8Q@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<1349863655-29320-14-git-send-email-zwu.kernel@gmail.com>
	<20121015003527.GA23324@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121015003527.GA23324@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 15, 2012 at 8:35 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Hi Zhi Yong,
>
> [cut...]
>> +3. The Design
>> +
>> +These include the following parts:
>> +
>> +    * Hooks in existing vfs functions to track data access frequency
>> +
>> +    * New rbtrees for tracking access frequency of inodes and sub-file
>              ^^^^^^^ s/rbtrees/radix-trees
>> +ranges (hot_rb.c)
>            ^^^^^^^^ Now it seems that all codes are in the same file.
HI, Zheng,

Good catch, i will update them, thanks.
>
> Regards,
> Zheng



-- 
Regards,

Zhi Yong Wu
