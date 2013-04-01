From: Anand Avati <avati-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH,
	RFC V3] ext3: add ioctl to force 32-bit hashes from indexed dirs
Date: Mon, 1 Apr 2013 13:34:15 -0700
Message-ID: <307C00EE-45DE-48A4-9FB7-3F164B51A524@redhat.com>
References: <51546EED.8030507@redhat.com> <5154AAB4.2000701@redhat.com>
	<5159A8D5.1000204@redhat.com> <20130401181718.GB22443@thunk.org>
	<5159D03F.5000606@redhat.com> <20130401190804.GD22443@thunk.org>
	<5159E4AC.7050307@redhat.com> <20130401200052.GA24097@thunk.org>
	<5159E88F.8030704@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, "J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	ext4 development <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
To: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <gluster-devel-bounces+gcfgd-gluster-devel=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
In-Reply-To: <5159E88F.8030704-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/gluster-devel>,
	<mailto:gluster-devel-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/gluster-devel>
List-Post: <mailto:gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Help: <mailto:gluster-devel-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/gluster-devel>,
	<mailto:gluster-devel-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=subscribe>
Errors-To: gluster-devel-bounces+gcfgd-gluster-devel=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
Sender: gluster-devel-bounces+gcfgd-gluster-devel=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


On Apr 1, 2013, at 1:05 PM, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> Meh, let's just keep it simple then.  And I'd really like to know if
> gluster still even needs this, or if their new scheme will work instead,

As of this morning the new d_off transformation (Zach's idea) is merged in gluster. We had to put in some kind of ext4 awareness, and the "more complex" d_off transformation (which is finally working properly after fixing some minor issues) seemed better than calling ioctls by detecting the backend is ext4.

> in  which case we should drop it - but Samba made noise about needing it too,
> though I've not seen specifics, so I hate to merge it "just in case."

Yes, I too saw comments from Andrew Bartlett of the Samba team. It appeared to be the case that Samba could only present 32bit cookies while ext4 was now returning larger cookies (somewhat like the old NFSv2 clients problem?). This ioctl would be useful there I guess, bring it "in par" with knfsd's abilities of expressing desire for 32bit cookies? However, for knfsd legacy requirements, FMODE_32BITHASH is in generic VFS. But for a userspace file server, it would need to first gain the knowledge of which filesystems in the world actually present large cookies, and for the subset which support smaller cookies, issue filesystem specific ioctls() in their own specific ways.

Wouldn't it be "fair" to treat userspace file servers as equals, and provide a generic FS independent ioctl to set the common FMODE_32BITHASH flag on any dir fd? Think of it as a way of extending the "pointer access" to file->f_mode which NFS exercises, up to userspace?

> I put it out mostly for review so it was ready if we needed it (since
> certain quarters seem anxious) ;)

Appreciate your help Eric!

Avati
