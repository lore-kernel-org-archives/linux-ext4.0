From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 01/28] ext4: xattr-in-inode support
Date: Wed, 31 May 2017 12:59:51 -0700
Message-ID: <CAAeU0aNCpaugXChSGBwm5RFYHBh8JweOqZ3rhq0b7EJvStrWeg@mail.gmail.com>
References: <20170531081517.11438-1-tahsin@google.com> <20170531164236.GJ4510@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jan Kara <jack@suse.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org,
        Andreas Dilger <andreas.dilger@intel.com>,
        Kalpak Shah <kalpak.shah@sun.com>,
        James Simmons <uja.ornl@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531164236.GJ4510@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>> allowing the ext4/e2fsck to verify the correct inode is accessed.
>
> Can we store the checksum of the xattr value somewhere?  We already
> checksum the values if they're stored in the ibody or a single external
> block, and I'd hate to lose that protection.
>
> We could probably reuse one of the inode fields (i_version?) for this.
>
The crc32c value of the xattr data is currently stored in the xattr inode:

struct ext4_xattr_ea_info {
__le64 ref_count; /* number of xattr entry references */
__le32 hash; /* crc32c hash of xattr data */
__le32 reserved; /* reserved, must be 0 */
};

We could also save that value in the ext4_xattr_entry->e_value_offs
for stronger binding between parent and xattr inodes. That field is
currently set to 0 for xattr inode references.
