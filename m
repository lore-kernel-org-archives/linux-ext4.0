From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] zero_user_page conversion
Date: Sat, 23 Jun 2007 09:51:57 -0700
Message-ID: <20070623095157.5a574afb.akpm@linux-foundation.org>
References: <4679A558.1010107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <samba-technical-bounces+gnsi-samba-technical=m.gmane.org@lists.samba.org>
In-Reply-To: <4679A558.1010107@redhat.com>
List-Unsubscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/archive/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces+gnsi-samba-technical=m.gmane.org@lists.samba.org
Errors-To: samba-technical-bounces+gnsi-samba-technical=m.gmane.org@lists.samba.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, 20 Jun 2007 17:08:24 -0500 Eric Sandeen <sandeen@redhat.com> wrote:
> Use zero_user_page() in cifs, ocfs2, ext4, and gfs2 where possible.

One patch, splattered across four maintainers, each of whom maintain separate
trees.

Sigh.  Please, don't.  _someone_ has to split this up, and it might as well
not be me.

<splits it up>
