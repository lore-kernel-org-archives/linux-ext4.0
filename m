From: "Ratna Manoj" <manoj.br@gmail.com>
Subject: Understanding ext3
Date: Sat, 11 Nov 2006 16:45:52 +0530
Message-ID: <7fbb0ada0611110315q68deec5bq58c42c892082ba81@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:440 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1161934AbWKKLPy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Nov 2006 06:15:54 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1612208nfa
        for <linux-ext4@vger.kernel.org>; Sat, 11 Nov 2006 03:15:52 -0800 (PST)
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

---------- Forwarded message ----------
From: Ratna Manoj <manoj.br@gmail.com>
Date: Nov 11, 2006 4:35 PM
Subject: sct@redhat.com
To: linux-ext4@vger.kernel.org


Hi,


int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
{
                        ..................
                        ..................

                         /*
                         * This buffer may be undergoing writeout in commit.  We
                         * can't return from here and let the caller dirty it
                         * again because that can cause the write-out loop in
                         * commit to never terminate.
                         */
                         if (buffer_dirty(bh)) {
                                 get_bh(bh);
                                 spin_unlock(&journal->j_list_lock);
                                 jbd_unlock_bh_state(bh);
                                 need_brelse = 1;
                                 sync_dirty_buffer(bh);
                                 jbd_lock_bh_state(bh);
                                 spin_lock(&journal->j_list_lock);
                                 /* The buffer may become locked again at any
                                    time if it is redirtied */
                         }
                         ..............................
                         ..............................
}


Can any body please explain how returning from the above function
cause write-out loop in commit to never terminate ?

If the current buffer is in the data_sync list of previous commiting
transaction, after returning from the journal_dirty_data,
generic_commit_write will redirty the buffer even though previous
commiting transaction commits the buffer to disk. Correct ?


-Ratna.
