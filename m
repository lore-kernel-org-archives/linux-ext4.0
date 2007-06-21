From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH] zero_user_page conversion
Date: Wed, 20 Jun 2007 17:21:16 -0700
Message-ID: <20070621002116.GB17713@ca-server1.us.oracle.com>
References: <4679A558.1010107@redhat.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cluster-devel@redhat.com, ext4 development <linux-ext4@vger.kernel.org>,
        samba-technical@lists.samba.org,
        linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <4679A558.1010107@redhat.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 20, 2007 at 05:08:24PM -0500, Eric Sandeen wrote:
> Use zero_user_page() in cifs, ocfs2, ext4, and gfs2 where possible.

Ok, the ocfs2 bits looked fine so I folded that part of the patch into
ocfs2.git, thanks.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
