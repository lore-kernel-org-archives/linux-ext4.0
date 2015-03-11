From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH RFC v2 1/6] fs: vfs ioctls for managing project id
Date: Wed, 11 Mar 2015 10:19:28 +0300
Message-ID: <CALYGNiNvT00VOfsy07QeB1dxRcb-7t0VRLqeRrzv89g9q0OLxg@mail.gmail.com>
References: <20150310171133.23081.49616.stgit@buzz>
	<20150310172205.23081.67263.stgit@buzz>
	<3403886C-8932-4CB0-8B1D-F468A5B199BA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3403886C-8932-4CB0-8B1D-F468A5B199BA@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 11, 2015 at 10:00 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> How do your patches relate to the project quota patches from Li Xi?

In v1 patchset was some modified patches from him, in v2 nothing left
from that code.
Probably couple hunks left in headers, for example the same magic
number is used for project quota inode. =)

>
> Cheers, Andreas
>
>> On Mar 10, 2015, at 13:22, Konstantin Khlebnikov <khlebnikov@yandex-team.ru> wrote:
>>
>> This patch adds generic vfs interface for project id and
>> related super-block methods.
>>
>> Two new ioctls:
>> int ioctl(fd, FS_IOC_GETPROJECT, unsigned *project);
>> int ioctl(fd, FS_IOC_SETPROJECT, unsigned *project);
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>> ---
