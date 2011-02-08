From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] VFS: call synchronize_rcu after kill_sb.
Date: Tue, 08 Feb 2011 19:25:44 +0200
Message-ID: <4D517C98.7060000@panasas.com>
References: <1296896481-3650-1-git-send-email-tm@tao.ma> <4D4FF040.9050707@panasas.com> <87hbceqxax.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <tm@tao.ma>, Nick Piggin <npiggin@kernel.dk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87hbceqxax.fsf@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/08/2011 06:57 PM, Aneesh Kumar K. V wrote:
> On Mon, 07 Feb 2011 15:14:40 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> On 02/05/2011 11:01 AM, Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>>
>>> In fa0d7e3, we use rcu free inode instead of freeing the inode
>>> directly. It causes a problem when we rmmod immediately after
>>> we umount the volume[1].
>>>
>>> So we need to call synchronize_rcu after we kill_sb so that
>>> the inode is freed before we do rmmod. The idea is inspired
>>> by Chris Mason[2]. I tested with ext4 by umount+rmmod and it
>>> doesn't show any error by now.
>>>
>>> 1. http://marc.info/?l=linux-fsdevel&m=129680863330185&w=2
>>> 2. http://marc.info/?l=linux-fsdevel&m=129684698713709&w=2 
>>>
>>> Cc: Nick Piggin <npiggin@kernel.dk>
>>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>>> Cc: Chris Mason <chris.mason@oracle.com>
>>> Cc: Boaz Harrosh <bharrosh@panasas.com>
>>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>>> ---
>>>  fs/super.c |    7 +++++++
>>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/super.c b/fs/super.c
>>> index 74e149e..315bce9 100644
>>> --- a/fs/super.c
>>> +++ b/fs/super.c
>>> @@ -177,6 +177,13 @@ void deactivate_locked_super(struct super_block *s)
>>>  	struct file_system_type *fs = s->s_type;
>>>  	if (atomic_dec_and_test(&s->s_active)) {
>>>  		fs->kill_sb(s);
>>> +		/*
>>> +		 * We need to synchronize rcu here so that
>>> +		 * the delayed rcu inode free can be executed
>>> +		 * before we put_super.
>>> +		 * https://bugzilla.kernel.org/show_bug.cgi?id=27652
>>> +		 */
>>> +		synchronize_rcu();
>>>  		put_filesystem(fs);
>>>  		put_super(s);
>>>  	} else {
>>
>>
<>
> 
> http://lwn.net/Articles/217484/ explains how to wait for rcu callback to finish
> 
> -aneesh

Yes thanks Aneesh, rcu_barrier does the trick
---
From: Boaz Harrosh <bharrosh@panasas.com>

In fa0d7e3, we use rcu free inode instead of freeing the inode
directly. It causes a problem when we rmmod immediately after
we umount the volume[1].

So we need to call rcu_barrier after we kill_sb so that
the inode is freed before we do rmmod. The idea is inspired
by Aneesh Kumar. rcu_barrier will wait for all callbacks
to end before preceding. The original patch was done by
Tao Ma, but synchronize_rcu() is not enough here.

1. http://marc.info/?l=linux-fsdevel&m=129680863330185&w=2
2. http://marc.info/?l=linux-fsdevel&m=129684698713709&w=2 

Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
git diff --stat -p -M fs/super.c
 fs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 74e149e..5fd4ec9 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -177,6 +177,13 @@ void deactivate_locked_super(struct super_block *s)
 	struct file_system_type *fs = s->s_type;
 	if (atomic_dec_and_test(&s->s_active)) {
 		fs->kill_sb(s);
+		/*
+		 * We need to synchronize rcu here so that
+		 * the delayed rcu inode free can be executed
+		 * before we put_super.
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=27652
+		 */
+		rcu_barrier();
 		put_filesystem(fs);
 		put_super(s);
 	} else {
