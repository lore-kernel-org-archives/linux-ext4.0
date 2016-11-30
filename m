From: Richard Weinberger <richard@nod.at>
Subject: Re: Idea behind EXT4_IOC_GET_ENCRYPTION_PWSALT?
Date: Wed, 30 Nov 2016 09:29:40 +0100
Message-ID: <9c61d812-9ec8-006d-bf24-775879678865@nod.at>
References: <bd1bb80f-f22c-1118-4438-f23372bad066@nod.at>
 <CAKpBdu3OUUjqVAwDTNUaVoyuPRun_t6U9gi1prgyoswzYPuOow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Michael Halcrow <mhalcrow@google.com>,
        Theodore Ts'o <tytso@mit.edu>, muslukhovi@gmail.com,
        David Gstir <david@sigma-star.at>
To: Joe Richey <joerichey@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAKpBdu3OUUjqVAwDTNUaVoyuPRun_t6U9gi1prgyoswzYPuOow@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Joe,

On 30.11.2016 01:44, Joe Richey wrote:
> Richard,
> 
> Our current design for fscrypt (tentative name for the userspace
> filesystem encryption manager) does not use the global filesystem salt
> (EXT4_IOC_GET_ENCRYPTION_PWSALT), we are planning on having a
> different salt for each password used in the system. We are using
> planning on using Argon2id as the password stretching algorithm, so
> we'll have costs for memory, time, and parallelism stored for each
> password as well as a salt.


Makes sense.
So, for now I'll not implement this ioctl command in UBIFS.

Thanks,
//richard

