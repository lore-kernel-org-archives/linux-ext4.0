From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH] Update atime from future.
Date: Mon, 03 Jan 2011 16:41:16 +0000
Message-ID: <1294072876.2429.110.camel@dolmen>
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com>
	 <1294050468.2429.2.camel@dolmen>
	 <E8737614-4ED4-4732-9B03-90811029A0F7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: yangsheng <sickamd@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E8737614-4ED4-4732-9B03-90811029A0F7@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Mon, 2011-01-03 at 09:27 -0700, Andreas Dilger wrote:
> On 2011-01-03, at 3:27, Steven Whitehouse <swhiteho@redhat.com> wrote:
> > On Wed, 2010-12-29 at 21:58 +0800, yangsheng wrote:
> >> Signed-off-by: sickamd@gmail.com
> >> ---
> >> fs/inode.c |    8 +++++++-
> >> 1 files changed, 7 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/fs/inode.c b/fs/inode.c
> >> index da85e56..6c8effd 100644
> >> --- a/fs/inode.c
> >> +++ b/fs/inode.c
> >> @@ -1469,7 +1469,13 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
> >>        return 1;
> >> 
> >>    /*
> >> -     * Is the previous atime value older than a day? If yes,
> >> +     * Is the previous atime value in future? If yes,
> >> +     * update atime:
> >> +     */
> >> +    if ((long)(now.tv_sec - inode->i_atime.tv_sec) < 0)
> >> +        return 1;
> >> +    /*
> >> +     * Is the previous atime value old than a day? If yes,
> >>     * update atime:
> >>     */
> >>    if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
> > 
> > I don't think this is a good plan for cluster filesystems, since if the
> > times on the nodes are not exactly synchronised (we do highly recommend
> > people run ntp or similar) then this might lead to excessive atime
> > updating. The current behaviour is to ignore atimes which are in the
> > future for exactly this reason,
> 
> The problem that is seen is if a tarball has stored a bad atime, or someone fat-fingers a "touch" then the future atime will never be fixed. Before the relatime patch, the future atime would be updated back to the current time on the next access. One if our regression tests for Lustre caught this. 
> 
> I wouldn't mind changing the relatime check so that it only updates the atime if it is more than one day in the future. That will avoid thrashing atime if the clocks are only slightly out of sync, but still allow fixing completely bogus atimes. 
> 
> Cheers, Andreas

That sounds like a good solution to me,

Steve.
