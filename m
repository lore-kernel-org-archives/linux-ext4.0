From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: ext4: Used block count in df
Date: Thu, 7 Feb 2013 12:09:05 +0530
Message-ID: <CANBXnM=H0ghqzQ5aJ_O+1C_sMJ850LQ9TOHLncOYkCKVSnUrAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I have an observation on EXT4 filesystem. I created filesystem of size
1TB, 4TB, and 7TB and then checked the output of df command.

df command showed the number of 1KB blocks used. The result was:
1TB: 204056
4TB: 198680
7TB: 181784

I performed the same on XFS and the result was:
1TB: 32928
4TB: 32928
7TB: 33024

EXT4 result shows with increasing filesystem size, the number of used
blocks decreased. I dont have idea about low level implementation but
I am curious why it is so?

Thanks.

Regards,
Adil
