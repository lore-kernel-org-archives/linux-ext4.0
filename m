From: Zhouyi Zhou <zhouzhouyi@gmail.com>
Subject: FS: EXT4: should we sync error info in __ext4_grp_locked_error?
Date: Thu, 14 Dec 2017 15:13:15 +0800
Message-ID: <CAABZP2w39PEBue-L1kGk-jh_WQohTtaVJHy-wS_E7QC28FKJSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, inux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
    In function __ext4_grp_locked_error,   __save_error_info(sb, function, line)
is called to save error info in super block block, but does not sync
that information
to disk to info the subsequence fsck after reboot. The reason, I guess
maybe it is
in locked state.
    My question is why not make a call ext4_commit_super(sb, 1) after
ext4_unlock_group(sb, grp) and  ext4_handle_error(sb), so that subsequence fsck
after reboot is sure to be well informed.
   Forgive my naiveness.
Thanks a lot
