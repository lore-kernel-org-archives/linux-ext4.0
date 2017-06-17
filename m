From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 30/31] ext4: eliminate xattr entry e_hash recalculation
 for removes
Date: Fri, 16 Jun 2017 19:04:44 -0700
Message-ID: <CAAeU0aMuV7EHw5ZwdF52__baS36CsaB4MN03iqUdyLh1Fc6HzA@mail.gmail.com>
References: <20170614172340.18720-1-tahsin@google.com> <20170615091026.GG1764@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.com>, "Theodore Ts'o" <tytso@mit.edu>,
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
        reiserfs-devel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20170615091026.GG1764@quack2.suse.cz>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 15, 2017 at 2:10 AM, Jan Kara <jack@suse.cz> wrote:
> I agree with moving ext4_xattr_rehash_entry() out of ext4_xattr_rehash().
> However how about just keeping ext4_xattr_rehash() in
> ext4_xattr_block_set() (so that you don't have to pass aditional argument
> to ext4_xattr_set_entry()) and calling ext4_xattr_rehash_entry() when
> i->value != NULL? That would seem easier and cleaner as well...

The is_block parameter is also used to decide whether block reserve
check should be performed:

@@ -1500,8 +1502,8 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
                 * attribute block so that a long value does not occupy the
                 * whole space and prevent futher entries being added.
                 */
-               if (ext4_has_feature_ea_inode(inode->i_sb) && new_size &&
-                   (s->end - s->base) == i_blocksize(inode) &&
+               if (ext4_has_feature_ea_inode(inode->i_sb) &&
+                   new_size && is_block &&
                    (min_offs + old_size - new_size) <
                                        EXT4_XATTR_BLOCK_RESERVE(inode)) {
                        ret = -ENOSPC;

Because of that, I think moving ext4_xattr_rehash to caller makes it
bit more complicated. Let me know if you disagree.
