From: Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [PATCH 2/6] [RFC] Create the .relink file_operation
Date: Wed, 29 Sep 2010 16:16:10 -0400
Message-ID: <4CA39E8A.1040805@cs.columbia.edu>
References: <6987185123220ec2034677299859c5a63eaf2aed.1285278339.git.matthltc@us.ibm.com>	<d91e3660266d3a2956c4d1aebc9cb618081b21ef.1285278339.git.matthltc@us.ibm.com>	<20100926190837.GA9308@cynthia.pants.nu>	<20100927191628.GN23839@count0.beaverton.ibm.com> <20100927220346.GA30726@cynthia.pants.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Matt Helsley <matthltc@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	containers@lists.linux-foundation.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Brad Boyer <flar@allandria.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100927220346.GA30726@cynthia.pants.nu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 09/27/2010 06:03 PM, Brad Boyer wrote:
> On Mon, Sep 27, 2010 at 12:16:28PM -0700, Matt Helsley wrote:
>> On Sun, Sep 26, 2010 at 12:08:37PM -0700, Brad Boyer wrote:
>>> On Thu, Sep 23, 2010 at 02:53:28PM -0700, Matt Helsley wrote:
>>>> Not all filesystems will necessarily be able to support relinking an
>>>> orphan inode back into the filesystem. Some offlist feedback suggested
>>>> that instead of overloading .link that relinking should be a separate
>>>> file operation for this reason.

In light of Brad's comment (below), maybe elaborate on this:

   Some offlist feedback suggested that instead of overloading .link
   to provide this functionality, relinking of an orphan inode back
   into the filesystem should be a separate file operation.
   This is because some filesystems may not be able to support this
   operation. Their existing .link already assumes that the inode
   isn't orphan (i_nlink != 0), but still won't explicitly test for
   the condition. If this is the case, the overloading .link may
   break their assumptions and a call to relink may not be handled
   too gracefully.

>>>>
>>>> Since .relink is a superset of .link make the VFS call .relink where
>>>> possible and .link otherwise.
>>>>
>>>> The next commit will change ext3/4 to enable this operation.
>>>
>>> I may have missed something in one of these patches (patch 1 and any
>>> original summary if there was one don't appear in my email), but
>>> what is the point of the new operation? I didn't see any case that
>>> treats one any different than the other. What is disallowed (and how)
>>> for a driver which does not implement .relink but has .link?
>>
>> Did you get patch 3? It shows how ext3/ext4 add the ability to take an
>> inode that has been unlinked, placed onto the orphan list, and relink it.
>
> Yes, I did get patch 3. I think you misunderstood my question. You point
> both .link and .relink to the same function in ext3 and ext4. The common
> code which calls them will call .relink if it is set and .link if it is
> not set. If nothing acts any different based on .relink being NULL or
> not-NULL, and the only implementation isn't any different from .link
> what was the point of introducing a new operation?
>
> What I expected to see was that some particular code path would check
> if .relink was NULL and fail in that case. Unless there is a code path
> that will only call .relink and not .link, it seems useless to me.

Does the above help clarify this ?
The test performed in vfs_link().

Oren.
