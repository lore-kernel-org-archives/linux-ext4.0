From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH RFC v2 2/6] fs: protected project id
Date: Tue, 10 Mar 2015 10:32:49 -0700
Message-ID: <CALCETrXE99fA1kwiXQvL0oTGZXa-nUwKdQ6_GfUPqXjOq8q0ZA@mail.gmail.com>
References: <20150310171133.23081.49616.stgit@buzz> <20150310172206.23081.95005.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Li Xi <pkuelelixi@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150310172206.23081.95005.stgit@buzz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 10, 2015 at 10:22 AM, Konstantin Khlebnikov
<khlebnikov@yandex-team.ru> wrote:
> Historically XFS project id doesn't have any permission control: file owner
> is able to set any project id. Later they was sealed with user-namespace:
> XFS allows to change it only from init user-ns. That works fine for isolated
> containers or if user doesn't have direct access to the filesystem (NFS/FTP).
>
> This patch adds sysctl fs.protected_projects which makes changing project id
> privileged operation which requires CAP_SYS_RESOURCE in current user-namespace.
> Thus there are two levels of protection: project id mapping in user-ns defines
> set of permitted projects and capability protects operations within this set.

If I understand this right, this doesn't work.  If I lack
CAP_SYS_RESOURCE but I have two projids mapped, then I can create a
new userns, map both projids, and get CAP_SYS_RESOURCE.

--Andy
