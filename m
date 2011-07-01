From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2v v7] XFS TESTS: ENOSPC Punch Hole Test
Date: Fri, 01 Jul 2011 07:30:19 -0700
Message-ID: <4E0DD9FB.8090307@linux.vnet.ibm.com>
References: <1309272301-5742-1-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1309272301-5742-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 06/28/2011 07:44 AM, Allison Henderson wrote:
> Hi All,
>
> This is another set I sent out a while ago, but I didnt see it show up on the lists,
> so I am resending this one too. The work in this patch is a continuation from a
> previous patch set that has been partially accepted, so I thought I
> should retain the v6.
>
> This patch set adds the ENOSPC test that was used for ext4 punch hole testing.
> This test will verify that a hole can be punched even when the disk is full.
> Reserved blocks should be used to complete the operation when there is not blocks
> to further fragment the file.
>
> Because punching a hole does not always require extra blocks, there needs to
> be serveal iterations of punching holes, and then filling the file system to 100%
> usage before it is forced to grow the tree in order to handle the fragmentation.
> The growing of the tree is what would cause ENOSPC if not for the use of reserved blocks.
>
> I could use some opinions on this patch set becuase I am not sure if other filesystems
> handle their punch holes in the same way.  Although xfs appears to pass the test,
> should this test be an ext4 only test? Thx!
>

Hi All,

I just wanted to poke this thread before too much time goes by.  This 
patch was initially part of an earlier set that's already been picked 
up, and it seemed like people were generally interested in it, so I 
resubmitted it as it's own patch.  Is there still an interest in this 
patch set?

I have another set that now also needs to add a new test 255 (the fix 
252 failure patch set).  I am thinking that if people still want this 
test, I could put this patch in with the other set so that they stack 
properly.  Thx!

Allison Henderson

