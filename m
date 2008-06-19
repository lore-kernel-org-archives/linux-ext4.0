From: "Dave Airlie" <airlied@gmail.com>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Thu, 19 Jun 2008 15:42:34 +1000
Message-ID: <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com>
References: <4859F075.2050207@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756490AbYFSFms@vger.kernel.org>
In-Reply-To: <4859F075.2050207@linux.intel.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 19, 2008 at 3:36 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> In the kerneloops.org stats, a new oops is rapidly climbing the charts.
> The oops is a page fault in the ext3 "do_slit" function, and the first
> report of it was with 2.6.26-rc6-git3.
>
> It happens with various applications; the backtraces are at:
>
> http://www.kerneloops.org/search.php?search=do_split
>

This is a bug in rawhide in gcc miscompiling something...

https://bugzilla.redhat.com/show_bug.cgi?id=451068

Dave.
