From: =?UTF-8?B?54Sm5pmT5Yas?= <milestonejxd@gmail.com>
Subject: metadata operation reordering regards to crash
Date: Fri, 14 Sep 2018 17:06:44 +0800
Message-ID: <CAJDTihzzLV3qwg0tGH_D4xAjCrgMy+oc4H9snpnMC_RC2q7nyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-kernel@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, all,

A probably bit of complex question:
Does nowadays practical filesystems, eg., extX, btfs, preserve metadata
operation order through a crash/power failure?

What I know is modern filesystems ensure metadata consistency
after crash/power failure. Journal filesystems like extX do that by
write-ahead logging of metadata operations into transactions. Other
filesystems do that in various ways as btfs do that by COW.

What I'm not so far clear is whether these filesystems preserve
metadata operation order after a crash.

For example,
op 1.  rename(A, B)
op 2.  rename(C, D)

As mentioned above,  metadata consistency is ensured after a crash.
Thus, B is either the original B(or not exists) or has been replaced by A.
The same to D.

Is it possible that, after a crash, D has been replaced by C but B is still
the original file(or not exists)?

Or, from the view of implementation, before the crash
- in a journal filesystem,
Is the atomic transaction `rename(C, D)` permitted to be written to disk journal
before the transaction `rename(A, B)`?
- in other filesystems, say btfs,
Is it permit to reorder `rename(C,D)` and `rename(A,B)` atomic operation hiting
disk?

The question is meaningful as many applications do that:
if (flag_file_says_need_generate_data) {
    open_write_sync_close(data_tmp);
    rename(data_tmp, data);

    open_write_sync_close(flag_file_tmp, no_need_to_generate_data);
    rename(flag_file_tmp, flag_file)
}
use_data_file()

If flag is here but data is not after a crash, that is a problem.

Thanks,
Trol
