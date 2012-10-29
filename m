From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 15/19] sysfs: add two hot_track proc files
Date: Tue, 30 Oct 2012 06:26:40 +0800
Message-ID: <CAEH94LiOSQeQcRz4cokTWKn2RBm8NxmP1Sqg2zyH6JLvU6=2vw@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-16-git-send-email-zwu.kernel@gmail.com>
	<20121029181040.GA3605@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121029181040.GA3605@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 30, 2012 at 2:10 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 29, 2012 at 12:30:57PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Add two proc files hot-kick-time and hot-update-delay
>> under the dir /proc/sys/fs/ in order to turn
>> TIME_TO_KICK and HEAT_UPDATE_DELAY into be tunable.
>
> As you say, these are proc files, not sysfs files, so please fix the
>  Subject: up here.
ah, OK, i will fix it, thanks for your pointing it out.
>
> thanks,
>
> greg k-h



-- 
Regards,

Zhi Yong Wu
