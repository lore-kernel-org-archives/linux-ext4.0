From: Richard Weinberger <richard@nod.at>
Subject: Idea behind EXT4_IOC_GET_ENCRYPTION_PWSALT?
Date: Tue, 29 Nov 2016 22:30:00 +0100
Message-ID: <bd1bb80f-f22c-1118-4438-f23372bad066@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        mhalcrow@google.com, tytso@mit.edu, muslukhovi@gmail.com,
        David Gstir <david@sigma-star.at>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

As the subject states, I'm a bit confused wrt. EXT4_IOC_GET_ENCRYPTION_PWSALT.
Will common fscrypt userspace depend on it?

IIUC you want to store some salt to seed the user password.
But what if /home/rw and /home/dags have different keys? Is it okay
to use the same salt for both keys?
Or is it an ad-hoc solution to allow an encrypted filesystem root
because you need a way to store the seed on the same filesystem but not as
file since all files are encrypted?
Wouldn't a xattr stored in the filesystem root directory also do it?

Long story short, I'm not sure whether we really need this ioctl command
in UBIFS and what the designated semantics are. :-)

Thanks,
//richard
