From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 1/3] ext4: Add EXT4_IOC_TRUNCATE_BLOCK_RANGE ioctl
Date: Mon, 24 Jun 2013 15:50:35 +0900
Message-ID: <CAKYAXd8j9qHbJR6eNK1SDuiiAYpa0ui_EWm1avQYuityw=mhOQ@mail.gmail.com>
References: <1371967656-3150-1-git-send-email-linkinjeon@gmail.com>
	<878v219ntd.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, a.sangwan@samsung.com,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878v219ntd.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2013/6/23, Dmitry Monakhov <dmonakhov@openvz.org>:
> On Sun, 23 Jun 2013 15:07:36 +0900, Namjae Jeon <linkinjeon@gmail.com>
> wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
Hi Dmitry.
> What is the difference between this ioctl and generic punch_hole?
It is different. Dave chinner already answered it.
>>
