From: Sunil <infinite.questions@gmail.com>
Subject: Re: inode and blocks
Date: Mon, 29 Sep 2008 22:54:05 +0530
Message-ID: <ef1901a00809291024u32bfabfo2961f0c63b32d267@mail.gmail.com>
References: <2d08ef090809280319m64555696nfe1a446e010f921f@mail.gmail.com>
	 <20080928210118.GD8711@mit.edu>
	 <2d08ef090809290733x2a58cfbl520be9810d772063@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_Part_38458_27317978.1222709045746"
Cc: "Theodore Tso" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: "Rohit Sharma" <imreckless@gmail.com>
Return-path: <kernelnewbies-bounce@nl.linux.org>
In-Reply-To: <2d08ef090809290733x2a58cfbl520be9810d772063@mail.gmail.com>
Sender: kernelnewbies-bounce@nl.linux.org
Errors-to: kernelnewbies-bounce@nl.linux.org
List-help: <mailto:ecartis@nl.linux.org?Subject=help>
List-unsubscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=unsubscribe>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=subscribe>
List-owner: <mailto:ecartis-owner@nl.linux.org>
List-post: <mailto:kernelnewbies@nl.linux.org>
List-archive: <http://mail.nl.linux.org/kernelnewbies/>
List-Id: linux-ext4.vger.kernel.org

------=_Part_38458_27317978.1222709045746
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Sep 29, 2008 at 8:03 PM, Rohit Sharma <imreckless@gmail.com> wrote:

> Not an assignment actually, but a project.
> We are working on open hierarchical storage management, in which we
> store files on disks according to different file placement policies.
> For eg. if i say that all the important files, like all the employee
> database should be in disk 1 and all the songs on disk 2, then we
> place them accordingly in different disks.
>
>
> On Mon, Sep 29, 2008 at 2:31 AM, Theodore Tso <tytso@mit.edu> wrote:
> > On Sun, Sep 28, 2008 at 03:49:04PM +0530, Rohit Sharma wrote:
> >> Suppose i have a file named abc.txt and i want to specify that
> >> all the *.txt files must be allocated between block groups no. 100 -
> >> 200 in ext2 fs.
> >>
> >> Is there a way to do this?
> >>
> >> can we modify function ext2_new_inode and find_group_orlov for this?
> >
> > You would have to modify kernel code to do this; the main question
> > which comes to mind is *why* would you want to do something like this?
> > It seems like an ideal problem set that a professor might give to a
> > student, since it would force them to try to get from an inode to the
> > pathname used to open the file.  So it seems to be one of these really
> > pointless things that isn't particularly useful in real life, except
> > for pedagogical purposes.
> >
> >                                                        - Ted
> >
>
> --
> To unsubscribe from this list: send an email with
> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
> Please read the FAQ at http://kernelnewbies.org/FAQ
>
>
Hi Rohit,

Just out of curiosity, how are you going to identify the type of file inside
kernel ? from an extension or file format ?

Thanks.

-- 
Sunil.

------=_Part_38458_27317978.1222709045746
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br><div class="gmail_quote">On Mon, Sep 29, 2008 at 8:03 PM, Rohit Sharma <span dir="ltr">&lt;<a href="mailto:imreckless@gmail.com">imreckless@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Not an assignment actually, but a project.<br>
We are working on open hierarchical storage management, in which we<br>
store files on disks according to different file placement policies.<br>
For eg. if i say that all the important files, like all the employee<br>
database should be in disk 1 and all the songs on disk 2, then we<br>
place them accordingly in different disks.<br>
<div><div></div><div class="Wj3C7c"><br>
<br>
On Mon, Sep 29, 2008 at 2:31 AM, Theodore Tso &lt;<a href="mailto:tytso@mit.edu">tytso@mit.edu</a>&gt; wrote:<br>
&gt; On Sun, Sep 28, 2008 at 03:49:04PM +0530, Rohit Sharma wrote:<br>
&gt;&gt; Suppose i have a file named abc.txt and i want to specify that<br>
&gt;&gt; all the *.txt files must be allocated between block groups no. 100 -<br>
&gt;&gt; 200 in ext2 fs.<br>
&gt;&gt;<br>
&gt;&gt; Is there a way to do this?<br>
&gt;&gt;<br>
&gt;&gt; can we modify function ext2_new_inode and find_group_orlov for this?<br>
&gt;<br>
&gt; You would have to modify kernel code to do this; the main question<br>
&gt; which comes to mind is *why* would you want to do something like this?<br>
&gt; It seems like an ideal problem set that a professor might give to a<br>
&gt; student, since it would force them to try to get from an inode to the<br>
&gt; pathname used to open the file. &nbsp;So it seems to be one of these really<br>
&gt; pointless things that isn&#39;t particularly useful in real life, except<br>
&gt; for pedagogical purposes.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;- Ted<br>
&gt;<br>
<br>
--<br>
To unsubscribe from this list: send an email with<br>
&quot;unsubscribe kernelnewbies&quot; to <a href="mailto:ecartis@nl.linux.org">ecartis@nl.linux.org</a><br>
Please read the FAQ at <a href="http://kernelnewbies.org/FAQ" target="_blank">http://kernelnewbies.org/FAQ</a><br>
<br>
</div></div></blockquote></div><br><span style="font-family: verdana,sans-serif;">Hi </span>Rohit<span style="font-family: verdana,sans-serif;">,</span><br style="font-family: verdana,sans-serif;"><br style="font-family: verdana,sans-serif;">
<span style="font-family: verdana,sans-serif;">Just out of curiosity, how are you going to identify the type of file inside kernel ? from an extension or file format ?</span><br style="font-family: verdana,sans-serif;" clear="all">
<br style="font-family: verdana,sans-serif;"><span style="font-family: verdana,sans-serif;">Thanks.</span><br style="font-family: verdana,sans-serif;"><br style="font-family: verdana,sans-serif;"><span style="font-family: verdana,sans-serif;">-- </span><br style="font-family: verdana,sans-serif;">
Sunil<span style="font-family: verdana,sans-serif;">.</span><br>
</div>

------=_Part_38458_27317978.1222709045746--

--
To unsubscribe from this list: send an email with
"unsubscribe kernelnewbies" to ecartis@nl.linux.org
Please read the FAQ at http://kernelnewbies.org/FAQ
